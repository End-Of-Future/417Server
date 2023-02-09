--奇异双面·师匠
local s,id,o=GetID()
function s.initial_effect(c)
--SPSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2311090,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
--Coin
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.coincon)
	e2:SetTarget(s.cointg)
	e2:SetOperation(s.coinop)
	c:RegisterEffect(e2)
end
c100121002.toss_coin=true
function s.filter(c)
	return c:IsSetCard(0x1cc1) and c:IsFaceup()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.coincon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function s.coinfi1(c,e,tp)
	return c:IsSetCard(0x1cc1) and c:IsCanBeSpecialSummoned(e,0,tp,0,0) and c:IsType(TYPE_MONSTER)
end
function s.coinfi2(c)
	return c:IsSetCard(0x2cc1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.coinfi1,tp,LOCATION_DECK,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(s.coinfi2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
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
		c:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
		if not Duel.IsExistingMatchingCard(s.coinfi1,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local mg=Duel.SelectMatchingCard(tp,s.coinfi1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #mg>0 then
			Duel.SpecialSummon(mg,0,tp,tp,0,0,POS_FACEUP)
		end
	elseif res==0 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		if not Duel.IsExistingMatchingCard(s.coinfi2,tp,LOCATION_DECK,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sc=Duel.SelectMatchingCard(tp,s.coinfi2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if sc then
			Duel.SSet(tp,sc)
			if sc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
			end
			if sc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
			end
		end
	end
end
function s.splimit(e,c)
	return not c:IsSetCard(0x1cc1)
end
