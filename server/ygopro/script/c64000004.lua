--灾临祸毒虫
function c64000004.initial_effect(c)
	aux.AddFusionProcFunFun(c,c64000004.fusion,c64000004.fusion1,1)
	c:EnableReviveLimit()
--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64000004,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,64000004+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c64000004.hspcon)
	e1:SetOperation(c64000004.hspop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64000004,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,64000004+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c64000004.hspcon1)
	e2:SetOperation(c64000004.hspop1)
	c:RegisterEffect(e2)
--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c64000004.efilter)
	c:RegisterEffect(e3)
--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,64000011)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c64000004.rmcon)
	e3:SetTarget(c64000004.rmtg)
	e3:SetOperation(c64000004.rmop)
	c:RegisterEffect(e3)
end
function c64000004.fusion(c)
	return c:GetOriginalRace()==RACE_INSECT and c:IsLevelAbove(5) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c64000004.fusion1(c)
	return c:GetOriginalRace()==RACE_INSECT and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c64000004.hspfilter(c,tp,sc)
	return c:GetOriginalRace()==RACE_INSECT and c:IsLevelAbove(5) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5)
		and c:IsControler(tp) and (Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c64000004.hspfilter1(c,tp,sc)
	return c:GetOriginalRace()==RACE_INSECT and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and (Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c64000004.hspfilter2(c,tp,sc)
	return c:IsType(TYPE_MONSTER)
end
function c64000004.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local fu=Duel.GetMatchingGroup(c64000004.hspfilter2,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	local fu1=Duel.GetMatchingGroup(c64000004.hspfilter2,tp,LOCATION_GRAVE,0,1,nil,tp,c)
	return fu:IsExists(c64000004.hspfilter,1,nil,tp,g,c) and fu1:IsExists(c64000004.hspfilter1,1,nil,tp,g,c)
end
function c64000004.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local fu=Duel.GetMatchingGroup(c64000004.hspfilter2,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	local fu1=Duel.GetMatchingGroup(c64000004.hspfilter2,tp,LOCATION_GRAVE,0,1,nil,tp,c)
	local eu=fu:FilterSelect(tp,c64000004.hspfilter,1,1,nil,tp,c)
	local du=eu:GetFirst()
	local eu1=fu1:FilterSelect(tp,c64000004.hspfilter1,1,1,nil,tp,c)
	local du1=eu1:GetFirst()
	if du:IsPosition(POS_FACEDOWN) then
	Duel.ConfirmCards(1-tp,du) end
	eu:Merge(eu1)
	Duel.SendtoDeck(eu,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c64000004.hspcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local fu2=Duel.GetMatchingGroup(c64000004.hspfilter2,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	local fu3=Duel.GetMatchingGroup(c64000004.hspfilter2,tp,LOCATION_GRAVE,0,1,nil,tp,c)
	return fu3:IsExists(c64000004.hspfilter,1,nil,tp,g,c) and fu2:IsExists(c64000004.hspfilter1,1,nil,tp,g,c)
end
function c64000004.hspop1(e,tp,eg,ep,ev,re,r,rp,c)
	local fu2=Duel.GetMatchingGroup(c64000004.hspfilter2,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
	local fu3=Duel.GetMatchingGroup(c64000004.hspfilter2,tp,LOCATION_GRAVE,0,1,nil,tp,c)
	local eu2=fu2:FilterSelect(tp,c64000004.hspfilter1,1,1,nil,tp,c)
	local du2=eu2:GetFirst()
	local eu3=fu3:FilterSelect(tp,c64000004.hspfilter,1,1,nil,tp,c)
	local du3=eu3:GetFirst()
	if du2:IsPosition(POS_FACEDOWN) then
	Duel.ConfirmCards(1-tp,du2) end
	eu2:Merge(eu3)
	Duel.SendtoDeck(eu2,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c64000004.efilter(e,te)
	if te:GetOwner()==e:GetOwner() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mc=tg:GetCount()
	if mc~=1 then return true end
	return not tg or not tg:IsContains(e:GetHandler())
end
function c64000004.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,64000004)==0
end
function c64000004.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,2)
end
function c64000004.rmfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) 
end
function c64000004.rmfilter1(c,e,tp)
	return c:IsAbleToRemove() 
end
function c64000004.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:FilterCount(c64000004.rmfilter,nil,e,tp)
	local ct1=g:GetCount()
	if ct>0
		and Duel.SelectYesNo(tp,aux.Stringid(64000004,2)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rmg=Duel.SelectTarget(tp,c64000004.rmfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,e:GetHandler(),tp)
		Duel.Remove(rmg,POS_FACEDOWN,REASON_EFFECT)
	end
	if ct1>0 then
		Duel.SortDecktop(tp,tp,ct1)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKTOP)
		end
	end
	Duel.Draw(tp,1,REASON_EFFECT)
Duel.RegisterFlagEffect(tp,64000004,RESET_PHASE+PHASE_END,0,2)
end