--德拉科尼亚帝国
function c213452974.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c213452974.atktg)
	e2:SetValue(c213452974.atkvalue)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(213452974,0))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,213452974)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c213452974.tgcon)
	e4:SetTarget(c213452974.tgtg)
	e4:SetOperation(c213452974.tgop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTarget(c213452974.sptg)
	e5:SetOperation(c213452974.spop)
	c:RegisterEffect(e5)
end
function c213452974.atktg(e,c)
	return c:IsType(TYPE_NORMAL)
end
function c213452974.atkfi(c)
	return c:IsType(TYPE_NORMAL) and c:IsFaceup()
end
function c213452974.atkvalue(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c213452974.atkfi,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return ct*500
end
function c213452974.cfi(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) 
		and c:IsPreviousLocation(LOCATION_MZONE) 
		and c:IsPreviousControler(tp) 
		and c:IsType(TYPE_NORMAL)
end
function c213452974.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c213452974.cfi,1,nil,tp)
end
function c213452974.tgfi(c)
	return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_MONSTER)
end
function c213452974.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c213452974.tgfi,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c213452974.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c213452974.tgfi,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
function c213452974.spfi(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,0,0)
end
function c213452974.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c213452974.spfi,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) and Duel.IsPlayerCanSpecialSummon(tp) 
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c213452974.spop(e,tp,eg,ep,ev,re,r,rp)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c213452974.spfi,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	if lc<=0 then return false end
	if lc>3 then lc=3 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then lc=1 end
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,lc)
		Duel.SpecialSummon(tg,0,tp,tp,0,0,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c213452974.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c213452974.splimit(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_MONSTER)
end
