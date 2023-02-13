--奇异双面·学徒
local s,id,o=GetID()
function s.initial_effect(c)
--Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
c100121001.toss_coin=true
function s.thfi1(c)
	return c:IsSetCard(0x1cc1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thfi2(c)
	return c:IsSetCard(0x2cc1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfi1,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(s.thfi2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local res=Duel.TossCoin(tp,1)
	if res==1 then
		c:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,00,aux.Stringid(id,1))
		if not Duel.IsExistingMatchingCard(s.thfi1,tp,LOCATION_DECK,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local mg=Duel.SelectMatchingCard(tp,s.thfi1,tp,LOCATION_DECK,0,1,1,nil)
		if #mg>0 then
			Duel.SendtoHand(mg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,mg)
	   end
	elseif res==0 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		if not Duel.IsExistingMatchingCard(s.thfi2,tp,LOCATION_DECK,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,s.thfi2,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function s.splimit(e,c)
	return not c:IsSetCard(0x1cc1)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsControler(tp) and not re:GetHandler():IsSetCard(0x1cc1,0x2cc1)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
