--岩石战士·II/
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,s.lkfi,2,2,nil)
	c:EnableReviveLimit()
--ChangeRace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(RACE_ROCK)
	c:RegisterEffect(e1)
--ChangePos & ChangeDef
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.tg)
	e2:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_DEFENSE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ROCK))
	e3:SetValue(1600)
	c:RegisterEffect(e3)
--BDingSearch|ToGrave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCountLimit(1,id)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.bdcon)
	e4:SetCost(s.bdcost)
	e4:SetTarget(s.bdtg)
	e4:SetOperation(s.bdop)
	c:RegisterEffect(e4)
--BDedToken
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCountLimit(1,id+o)
	e5:SetCondition(s.tokencon)
	e5:SetCost(s.tokencost)
	e5:SetTarget(s.tokentg)
	e5:SetOperation(s.tokenop)
	c:RegisterEffect(e5)
end
function s.lkfi(c)
	return c:IsRace(RACE_ROCK) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.tg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_ROCK)
end
function s.bdfi(e,c)
	return c:GetPreviousControler()==1-e:GetHandlerPlayer() and c:GetPreviousRaceOnField()&RACE_ROCK~=0
end
function s.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	return s.bdfi(e,tc)
end
function s.bdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.thgfi(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ROCK) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thgfi,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.togfi(c,lv)
	return c:IsOnField() and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(lv) and c:IsAbleToGrave()
end
function s.bdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc=Duel.SelectMatchingCard(tp,s.thgfi,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and tc:IsAbleToGrave() and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1191,1190)==0) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
			goto stg
		return true end
	else
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,tc)
			goto stg
		return true end
	end
	::stg::
	if Duel.IsExistingMatchingCard(s.togfi,tp,0,LOCATION_MZONE,1,nil,tc:GetLevel()) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tog=Duel.SelectMatchingCard(tp,s.togfi,tp,0,LOCATION_MZONE,1,1,nil)
		if #tog>0 then Duel.SendtoGrave(tog,REASON_EFFECT) end
	end
end
function s.costfi(c)
	return c:IsRace(RACE_ROCK) and c:IsAbleToGraveAsCost()
end
function s.tokencon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return Duel.GetBattleDamage(tp)>0
		and ((a:IsControler(tp) and a==e:GetHandler()) or (at and at:IsControler(tp) and at==e:GetHandler()))
end
function s.tokencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfi,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfi,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,100555795,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_ROCK,ATTRIBUTE_EARTH) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function s.tokenop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLED)
		e2:SetOperation(s.tokenop)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.tokenop(e,tp,eg,ep,ev,re,r,rp)
	for i=1,2 do
		local token=Duel.CreateToken(tp,100555795)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
